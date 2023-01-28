{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, docutils
, mistune
, pygments
}:

buildPythonPackage rec {
  pname = "m2r";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf90bad66cda1164b17e5ba4a037806d2443f2a4d5ddc9f6a5554a0322aaed99";
  };

  patches = [
    # fix tests in python 3.10
    (fetchpatch {
      url = "https://github.com/miyakogi/m2r/commit/58ee9cabdadf5e3deb13037f3052238f0f2bffcd.patch";
      sha256 = "sha256-CN3PWmnk7xsn1wngRHuEWmDTP3HtVNxkFv0xzD2Zjlo=";
    })
    ./docutils-0.19-compat.patch
  ];

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace "optional" "positional"
  '';

  propagatedBuildInputs = [ mistune docutils ];

  nativeCheckInputs = [ pygments ];

  meta = with lib; {
    homepage = "https://github.com/miyakogi/m2r";
    description = "Markdown to reStructuredText converter";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres SuperSandro2000 ];
    # https://github.com/miyakogi/m2r/issues/66
    broken = versionAtLeast mistune.version "2";
  };
}
