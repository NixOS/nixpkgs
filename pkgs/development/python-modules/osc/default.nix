{
  bashInteractive,
  buildPythonPackage,
  cryptography,
  diffstat,
  fetchFromGitHub,
  lib,
  rpm,
  setuptools,
  urllib3,
  keyring,
  ruamel-yaml,
}:

buildPythonPackage rec {
  pname = "osc";
  version = "1.27.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "osc";
    tag = version;
    hash = "sha256-We8SuDa2phvvu9IcsBWu/YBHPvlPy0Yka716KKcFwJ8=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ bashInteractive ]; # needed for bash-completion helper
  nativeCheckInputs = [
    rpm
    diffstat
  ];
  dependencies = [
    urllib3
    cryptography
    keyring
    ruamel-yaml
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

  preCheck = "HOME=$TMPDIR";

  meta = {
    homepage = "https://github.com/openSUSE/osc";
    description = "Opensuse-commander with svn like handling";
    mainProgram = "osc";
    maintainers = with lib.maintainers; [
      peti
      saschagrunert
    ];
    license = lib.licenses.gpl2Plus;
  };
}
