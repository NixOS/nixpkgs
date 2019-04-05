{ lib, fetchPypi, buildPythonApplication, EditorConfig, fetchpatch, pytest, six }:

buildPythonApplication rec {
  pname = "jsbeautifier";
  version = "1.8.9";

  propagatedBuildInputs = [ six ];

  buildInputs = [ EditorConfig pytest ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d02baa9b0459bf9c5407c1b99ad5566de04a3b664b18a58ac64f52832034204";
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
