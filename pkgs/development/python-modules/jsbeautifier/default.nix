{ lib, fetchPypi, buildPythonApplication, EditorConfig, fetchpatch, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.9.1";

  propagatedBuildInputs = [ six EditorConfig ];
  checkInputs = [ pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8ld072dkccssagjxyvc9633fb6ynflvz70924phgp3zxmim960";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/beautify-web/js-beautify/commit/78e35a11cbb805fc044241d6465800ee2bd57ebc.patch";
      sha256 = "1ah7nshk96yljy37i20v4fga834dix9cdbhkdc3flfm4904n4523";
    })
  ];

  patchFlags = [ "-p2" ];

  meta = with lib; {
    homepage    = "http://jsbeautifier.org";
    description = "JavaScript unobfuscator and beautifier.";
    license     = licenses.mit;
    maintainers = with maintainers; [ apeyroux ];
  };
}
