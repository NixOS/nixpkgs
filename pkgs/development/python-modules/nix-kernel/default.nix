{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  isPy3k,
  pexpect,
  notebook,
  nix,
}:

buildPythonPackage rec {
  pname = "nix-kernel";
  version = "unstable-2020-04-26";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "GTrunSec";
    repo = "nix-kernel";
    rev = "dfa42d0812d508ded99f690ee1a83281d900a3ec";
    sha256 = "1lf4rbbxjmq9h6g3wrdzx3v3dn1bndfmiybxiy0sjavgb6lzc8kq";
  };

  postPatch = ''
    substituteInPlace nix-kernel/kernel.py \
      --replace-fail "'nix'" "'${nix}/bin/nix'" \
      --replace-fail "'nix repl'" "'${nix}/bin/nix repl'"

    substituteInPlace setup.py \
      --replace-fail "cmdclass={'install': install_with_kernelspec}," ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    pexpect
    notebook
  ];

  # no tests in repo
  doCheck = false;

  pythonImportsCheck = [ "nix-kernel" ];

  meta = with lib; {
    description = "Simple jupyter kernel for nix-repl";
    homepage = "https://github.com/GTrunSec/nix-kernel";
    license = licenses.mit;
    maintainers = [ ];
  };
}
