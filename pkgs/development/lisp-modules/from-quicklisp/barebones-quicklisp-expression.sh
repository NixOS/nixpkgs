#! /bin/sh

name="$1"

nix-instantiate "$(dirname "$0")"/../../../../ -A "lispPackages.$name" > /dev/null && exit
[ "$NIX_LISP_PACKAGES_DEFINED" != "${NIX_LISP_PACKAGES_DEFINED/$name/@@}" ] && exit

NIX_LISP_PACKAGES_DEFINED="$NIX_LISP_PACKAGES_DEFINED $1 "

[ -z "$NIX_QUICKLISP_DIR" ] && {
  export NIX_QUICKLISP_DIR="$(mktemp -d --tmpdir nix-quicklisp.XXXXXX)"
}

[ -f "$NIX_QUICKLISP_DIR/setup.lisp" ] || {
  "$(dirname "$0")/quicklisp-beta-env.sh" "$NIX_QUICKLISP_DIR" &> /dev/null < /dev/null
}

description="$("$(dirname "$0")/asdf-description.sh" "$name")"
[ -z "$description" ] && {
  description="$(curl -L https://github.com/quicklisp/quicklisp-projects/raw/master/"$name"/description.txt)"
  [ "$(echo "$description" | wc -l)" -gt 10 ] && description=""
}

dependencies="$("$(dirname "$0")/quicklisp-dependencies.sh" "$name" | xargs)"
ql_src="$(curl -L https://github.com/quicklisp/quicklisp-projects/raw/master/"$name"/source.txt)"
ql_src_type="${ql_src%% *}"
url="${ql_src##* }"

[ "$ql_src_type" = git ] && {
  fetcher="pkgs.fetchgit"
  [ "${url#git://github.com/}" != "$url" ] && {
    url="${url/git:/https:}"
    url="${url%.git}"
    rev=$("$(dirname "$0")/../../../build-support/upstream-updater/urls-from-page.sh" "$url/commits" | grep /commit/ | head -n 1 | xargs basename)
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev")
    version="git-$(date +%Y%m%d)";
  }
  [ "${url#git://common-lisp.net/}" != "$url" ] && {
    http_repo_url="$url"
    http_repo_url="${http_repo_url/git:/http:}"
    http_repo_url="${http_repo_url/\/projects\// /r/projects/}"
    http_repo_head="$http_repo_url/refs/heads/master"
    echo "$http_repo_head" >&2
    rev=$(curl -L "$http_repo_head");
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev")
    version="git-$(date +%Y%m%d)";
  }
}

[ "$ql_src_type" = cvs ] && {
  fetcher="pkgs.fetchcvs"
  date="$(date -d yesterday +%Y-%m-%d)"
  version="cvs-$date"
  module="${module:-$name}"
  hash=$(USE_DATE=1 "$(dirname "$0")/../../../build-support/fetchcvs/nix-prefetch-cvs" "$url" "$module" "$date")
  cvsRoot="$url"
  unset url
}

cat << EOF

  $name = buildLispPackage rec {
    baseName = "$name";
    version = "${version:-\${Set me //}";
    description = "$description";
    deps = [$dependencies];
    src = ${fetcher:-pkgs.fetchurl} {
      ${url:+url = ''$url'';}
      sha256 = "${hash:-0000000000000000000000000000000000000000000000000000000000000000}";
      ${rev:+rev = ''$rev'';}
      ${date:+date = ''$date'';}
      ${module:+module = ''$module'';}
      ${cvsRoot:+cvsRoot = ''$cvsRoot'';}
    };
  };
EOF

for i in $dependencies; do "$0" "$i"; done
