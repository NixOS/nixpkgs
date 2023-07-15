{ stdenv, lib, buildPythonPackage, fetchFromGitHub, bashInteractive
, rpm, urllib3, cryptography, diffstat
}:

buildPythonPackage rec {
  pname = "osc";
  version = "1.0.0b1";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
    sha256 = "cMltsR4Nxe0plHU5cP2Lj/qqlIqRbCXi6FXP8qx7908=";
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  nativeCheckInputs = [ rpm diffstat ];
  propagatedBuildInputs = [ urllib3 cryptography ];

  postInstall = ''
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

  preCheck = "HOME=$TOP/tmp";

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/openSUSE/osc";
    description = "opensuse-commander with svn like handling";
    maintainers = [ maintainers.peti ];
    license = licenses.gpl2;
  };

}
