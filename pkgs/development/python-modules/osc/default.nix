{ stdenv, lib, buildPythonPackage, fetchFromGitHub, bashInteractive, urlgrabber
, m2crypto, rpm, chardet
}:

buildPythonPackage rec {
  pname = "osc";
  version = "0.170.0";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
    sha256 = "10dj9kscz59qm8rw5084gf0m8ail2rl7r8rg66ij92x88wvi9mbz";
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  checkInputs = [ rpm ];
  propagatedBuildInputs = [ urlgrabber m2crypto chardet ];

  postInstall = ''
    ln -s $out/bin/osc-wrapper.py $out/bin/osc
    install -D -m444 osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 dist/osc.complete $out/share/bash-completion/helpers/osc-helper
    mkdir -p $out/share/bash-completion/completions
    cat >>$out/share/bash-completion/completions/osc <<EOF
    test -z "\$BASH_VERSION" && return
    complete -o default _nullcommand >/dev/null 2>&1 || return
    complete -r _nullcommand >/dev/null 2>&1         || return
    complete -o default -C $out/share/bash-completion/helpers/osc-helper osc
    EOF
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/openSUSE/osc";
    description = "opensuse-commander with svn like handling";
    maintainers = [ maintainers.peti ];
    license = licenses.gpl2;
  };

}
