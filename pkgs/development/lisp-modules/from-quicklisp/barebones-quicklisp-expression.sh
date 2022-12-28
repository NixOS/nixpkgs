#! /bin/sh

name="$1"

[ -z "$NIX_LISP_PACKAGES_DEFINED_LIST" ] && export NIX_LISP_PACKAGES_DEFINED_LIST="$(mktemp)"

if [ -n "$NIX_LISP_UPDATE_PACKAGE" ] || [ -n "$NIX_LISP_UPDATE_PACKAGES" ]; then
  export NIX_LISP_UPDATE_PACKAGE=
else
  nix-instantiate "$(dirname "$0")"/../../../../ -A "lispPackages.$name" > /dev/null && exit
fi
grep "^$name\$" "$NIX_LISP_PACKAGES_DEFINED_LIST" > /dev/null && exit

echo "$name" >> "$NIX_LISP_PACKAGES_DEFINED_LIST"

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

[ "$ql_src_type" = "kmr-git" ] && {
  ql_src_type=git
  url="http://git.kpe.io/$url.git"
  export NIX_PREFETCH_GIT_DEEP_CLONE=1
}

[ "$ql_src_type" = ediware-http ] && {
  ql_src_type=github
  url="edicl/$url";
}

[ "$ql_src_type" = xach-http ] && {
  ql_src_type=github
  url="xach/$url";
}

[ "$ql_src_type" = github ] && {
  ql_src_type=git
  url="https://github.com/$url";
  version="$("$(dirname "$0")/urls-from-page.sh" "$url/releases/" | grep /tag/ | head -n 1 | xargs -l1 basename)"
  rev="refs/tags/$version";
}

[ "$ql_src_type" = git ] && {
  fetcher="pkgs.fetchgit"
  ( [ "${url#git://github.com/}" != "$url" ] ||
    [ "${url#https://github.com/}" != "$url" ]
    ) && {
    url="${url/git:/https:}"
    url="${url%.git}"
    [ -z "$rev" ] && rev=$("$(dirname "$0")/urls-from-page.sh" "$url/commits" | grep /commit/ | head -n 1 | xargs basename)
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev" | grep . | tail -n 1)
    [ -z "$version" ] && version="git-$(date +%Y%m%d)";
  }
  [ "${url#git://common-lisp.net/}" != "$url" ] && {
    http_repo_url="$url"
    http_repo_url="${http_repo_url/git:/http:}"
    http_repo_url="${http_repo_url/\/projects\// /r/projects/}"
    http_repo_head="$http_repo_url/refs/heads/master"
    echo "$http_repo_head" >&2
    [ -z "$rev" ] && rev=$(curl -L "$http_repo_head");
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev")
    [ -z "$version" ] && version="git-$(date +%Y%m%d)";
  }
  [ "${url#http://git.b9.com/}" != "$url" ] && {
    http_repo_url="$url"
    http_repo_url="${http_repo_url/git:/http:}"
    http_repo_head="$http_repo_url/refs/heads/master"
    echo "$http_repo_head" >&2
    rev=$(curl -L "$http_repo_head");
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev" | tail -n 1)
    version="git-$(date +%Y%m%d)";
  }
  [ "${url#http://common-lisp.net/}" != "$url" ] && {
    http_repo_url="$url"
    http_repo_url="${http_repo_url/git:/http:}"
    http_repo_head="$http_repo_url/refs/heads/master"
    echo "$http_repo_head" >&2
    rev=$(curl -L "$http_repo_head");
    hash=$("$(dirname "$0")/../../../build-support/fetchgit/nix-prefetch-git" "$url" "$rev" | tail -n 1)
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

[ "$ql_src_type" = clnet-darcs ] && {
  ql_src_type=darcs
  url="http://common-lisp.net/project/$url/darcs/$url/"
}

[ "$ql_src_type" = darcs ] && {
  fetcher="pkgs.fetchdarcs"
  [ -z "$version" ] &&
  version="$(curl "$url/_darcs/inventory" | grep '\[TAG ' | tail -n 1 | sed -e 's/.* //')"
  [ -z "$version" ] &&
  version="$(curl "$url/_darcs/hashed_inventory" | grep '\[TAG ' | tail -n 1 | sed -e 's/.* //')"
  rev="$version";
  hash=$(echo "
  with (import <nixpkgs> {});
      fetchdarcs {
        url=''$url'';
    rev=''$version'';
    sha256=''0000000000000000000000000000000000000000000000000000000000000000'';
    }" | nix-instantiate - | tail -n 1 |
    xargs nix-store -r 2>&1 | tee /dev/stderr | grep 'instead has' | tail -n 1 |
    sed -e 's/.* instead has .//;s/[^0-9a-z].*//')
}

[ "$ql_src_type" = froydware-http ] && {
  dirurl="http://method-combination.net/lisp/files/";
  url="$("$(dirname "$0")/urls-from-page.sh" "$dirurl" |
    grep "/${url}_" | grep -v "[.]asc\$" | tail -n 1)"
  ql_src_type=http
}

[ "$ql_src_type" = http ] && {
  fetcher="pkgs.fetchurl";
  version="$(echo "$url" | sed -re 's@.*[-_]([0-9.]+)[-._].*@\1@')"
  hash="$(nix-prefetch-url "$url" | grep . | tail -n 1)"
}

[ "$ql_src_type" = https ] && {
  fetcher="pkgs.fetchurl";
  version="$(echo "$url" | sed -re 's@.*[-_]([0-9.]+)[-._].*@\1@')"
  hash="$(nix-prefetch-url "$url" | grep . | tail -n 1)"
}

if [ "$ql_src" = '{"error":"Not Found"}' ]; then
    echo "# $name: not found"
else
cat << EOF | grep -Ev '^[ ]+$'

  $name = buildLispPackage rec {
    baseName = "$name";
    version = "${version:-\${Set me //}";
    description = "$description";
    deps = [$dependencies];
    # Source type: $ql_src_type
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
fi

for i in $dependencies; do "$0" "$i"; done
