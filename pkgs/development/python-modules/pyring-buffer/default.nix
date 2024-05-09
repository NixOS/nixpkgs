{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools
}:

buildPythonPackage rec {
  pname = "pyring-buffer";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "pyring-buffer";
    rev = "382290312fa2ad5d75bd42c040a43e25dad9c8a7";
    hash = "sha256-bHhcBU4tjFAyZ3/GjaP/hDXz2N73mCChTNYHsZyBCSM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "pyring_buffer"
  ];

  meta = with lib; {
    description = "A pure Python ring buffer for bytes";
    homepage = "https://github.com/rhasspy/pyring-buffer";
    changelog = "https://github.com/rhasspy/pyring-buffer/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
