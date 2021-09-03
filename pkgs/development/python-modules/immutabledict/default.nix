{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "immutabledict";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "corenting";
    repo = "immutabledict";
    rev = "v${version}";
    sha256 = "1n71154nfb6vr41iv00xcwkxmwnn1vwzbr3s23bjvlhvmnjb48a8";
  };

  # https://github.com/corenting/immutabledict/issues/56
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  pythonImportsCheck = [
    "immutabledict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A fork of frozendict, an immutable wrapper around dictionaries";
    homepage = "https://github.com/corenting/immutabledict";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}

