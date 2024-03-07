{ stdenv
, bashInteractive
, buildPythonPackage
, cryptography
, diffstat
, fetchFromGitHub
, lib
, rpm
, urllib3
}:

buildPythonPackage rec {
  pname = "osc";
  version = "1.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
    sha256 = "sha256-pywSXGM3IX3cTr1uJIP7pNGIYE/skMIoJeoaMU75zwc=";
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  nativeCheckInputs = [ rpm diffstat ];
  propagatedBuildInputs = [ urllib3 cryptography ];

  postInstall = ''
    install -D -m444 contrib/osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 contrib/osc.complete $out/share/bash-completion/helpers/osc-helper
    mkdir -p $out/share/bash-completion/completions
    cat >>$out/share/bash-completion/completions/osc <<EOF
    test -z "\$BASH_VERSION" && return
    complete -o default _nullcommand >/dev/null 2>&1 || return
    complete -r _nullcommand >/dev/null 2>&1         || return
    complete -o default -C $out/share/bash-completion/helpers/osc-helper osc
    EOF
  '';

  preCheck = "HOME=$TOP/tmp";

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/openSUSE/osc";
    description = "opensuse-commander with svn like handling";
    maintainers = [ maintainers.peti ];
    license = licenses.gpl2;
  };

}
