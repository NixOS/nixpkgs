{ lib
, buildPythonPackage
, fetchPypi
, installShellFiles
, importlib-metadata
, jinja2
, rich
, pyaml
, gitpython
, typer
, giturlparse
}:

buildPythonPackage rec {
  pname = "ansible-gendoc";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "tZj40TzmhPUPANCL48Jsmeyzv8PVFHtsSdKQPkS0b+k=";
  };

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = [
    importlib-metadata
    jinja2
    rich
    pyaml
    gitpython
    typer
    giturlparse
  ];

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd ansible-gendoc \
          --bash <($out/bin/ansible-gendoc --show-completion bash) \
          --fish <($out/bin/ansible-gendoc --show-completion fish) \
          --zsh <($out/bin/ansible-gendoc --show-completion zsh)
  '';

  meta = {
    description = "Auto generate Ansible documentation";
    mainProgram = "ansible-gendoc";
    homepage = "https://github.com/claranet/ansible-gendoc";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ sailord vinetos ];
  };
}
