{
  lib,
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "rtf-tokenize";
  version = "1.0.0";

  meta = with lib; {
    description = "A simple RTF tokenizer";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "rtf_tokenize";
    inherit version;
    hash = "sha256-XD3zkNAEeb12N8gjv81v37Id3RuWroFUY95+HtOS1gg=";
  };
}
