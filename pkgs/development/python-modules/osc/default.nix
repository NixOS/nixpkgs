{
  stdenv,
  bashInteractive,
  buildPythonPackage,
  cryptography,
  diffstat,
  fetchFromGitHub,
  lib,
  rpm,
  urllib3,
  keyring,
}:

buildPythonPackage rec {
  pname = "osc";
  version = "1.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    rev = version;
    hash = "sha256-YYcTZ4TB/wDl+T3yF5n2Wp0r4v8eWCTO2fjv/ygicmM=";
  };

  buildInputs = [ bashInteractive ]; # needed for bash-completion helper
  nativeCheckInputs = [
    rpm
    diffstat
  ];
  propagatedBuildInputs = [
    urllib3
    cryptography
    keyring
  ];

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
    mainProgram = "osc";
    maintainers = with maintainers; [
      peti
      saschagrunert
    ];
    license = licenses.gpl2;
  };
}
