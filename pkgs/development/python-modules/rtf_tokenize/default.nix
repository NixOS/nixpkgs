{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtf_tokenize";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    inherit pname version;
    owner = "openstenoproject";
    repo = "rtf_tokenize";
    rev = "${version}";
    hash = "sha256-zwD2sRYTY1Kmm/Ag2hps9VRdUyQoi4zKtDPR+F52t9A=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "rtf_tokenize" ];

  meta = with lib; {
    description = "A simple RTF tokenizer.";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      nilscc
    ];
  };
}
