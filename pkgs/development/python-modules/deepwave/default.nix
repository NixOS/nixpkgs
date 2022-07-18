{ lib
, buildPythonPackage
, fetchFromGitHub
, pytorch
, ninja
, scipy
, which
, pybind11
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deepwave";
  version = "0.0.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ar4";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d4EahmzHACHaeKoNZy63OKwWZdlHbUydrbr4fD43X8s=";
  };

  # unable to find ninja although it is available, most likely because it looks for its pip version
  postPatch = ''
    substituteInPlace setup.cfg --replace "ninja" ""
  '';

  # The source files are compiled at runtime and cached at the
  # $HOME/.cache folder, so for the check phase it is needed to
  # have a temporary home. This is also the reason ninja is not
  # needed at the nativeBuildInputs, since it will only be used
  # at runtime. The user will have to add it to its nix-shell
  # along with deepwave
  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  propagatedBuildInputs = [ pytorch pybind11 ];

  checkInputs = [
    ninja
    which
    scipy
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deepwave" ];

  meta = with lib; {
    description = "Wave propagation modules for PyTorch";
    homepage = "https://github.com/ar4/deepwave";
    license = licenses.mit;
    platforms = intersectLists platforms.x86_64 platforms.linux;
    maintainers = with maintainers; [ atila ];
  };
}
