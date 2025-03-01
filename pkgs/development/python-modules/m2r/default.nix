{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  docutils,
  mistune,
  pygments,
}:

buildPythonPackage rec {
  pname = "m2r";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qvtn/EnPsdieRqNEOsdH4V9LtC3yDtBPBnrZ777iVqs=";
  };

  patches = [
    # fix tests in python 3.10
    (fetchpatch {
      url = "https://github.com/miyakogi/m2r/commit/58ee9cabdadf5e3deb13037f3052238f0f2bffcd.patch";
      hash = "sha256-CN3PWmnk7xsn1wngRHuEWmDTP3HtVNxkFv0xzD2Zjlo=";
    })
    ./docutils-0.19-compat.patch
  ];

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace "optional" "positional"
  '';

  propagatedBuildInputs = [
    mistune
    docutils
  ];

  nativeCheckInputs = [ pygments ];

  meta = with lib; {
    homepage = "https://github.com/miyakogi/m2r";
    description = "Markdown to reStructuredText converter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    # https://github.com/miyakogi/m2r/issues/66
    broken = versionAtLeast mistune.version "2";
  };
}
