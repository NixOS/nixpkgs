{ stdenv, lib, buildPythonPackage, fetchFromGitHub, bashInteractive
, rpm, urllib3, cryptography, diffstat
}:

buildPythonPackage rec {
  pname = "osc";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.0.0b1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-gHcPqo3AuSrVprYUGLenC0kw9hKNmjabZ1m6YVMsNPs=";
=======
    sha256 = "cMltsR4Nxe0plHU5cP2Lj/qqlIqRbCXi6FXP8qx7908=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  nativeCheckInputs = [ rpm diffstat ];
  propagatedBuildInputs = [ urllib3 cryptography ];

  postInstall = ''
<<<<<<< HEAD
    install -D -m444 contrib/osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 contrib/osc.complete $out/share/bash-completion/helpers/osc-helper
=======
    install -D -m444 osc.fish $out/etc/fish/completions/osc.fish
    install -D -m555 dist/osc.complete $out/share/bash-completion/helpers/osc-helper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
