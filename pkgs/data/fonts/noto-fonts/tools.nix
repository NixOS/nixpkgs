{ fetchFromGitHub, lib, fetchpatch, buildPythonPackage, isPy3k, fonttools, numpy, pillow, six, bash }:

buildPythonPackage rec {
  pname = "nototools";
  version = "unstable-2019-10-21";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "nototools";
    rev = "cae92ce958bee37748bf0602f5d7d97bb6db98ca";
    sha256 = "1jqr0dz23rjqiyxw1w69l6ry16dwdcf3c6cysiy793g2v7pir2yi";
  };

  propagatedBuildInputs = [ fonttools numpy ];

  patches = lib.optionals isPy3k [
    # Additional Python 3 compat https://github.com/googlefonts/nototools/pull/497
    (fetchpatch {
      url = https://github.com/googlefonts/nototools/commit/ded1f311b3260f015b5c5b80f05f7185392c4eff.patch;
      sha256 = "0bn0rlbddxicw0h1dnl0cibgj6xjalja2qcm563y7kk3z5cdwhgq";
    })
  ];

  postPatch = ''
    sed -ie "s^join(_DATA_DIR_PATH,^join(\"$out/third_party/ucd\",^" nototools/unicode_data.py
  '';

  checkInputs = [
    pillow six bash
  ];

  checkPhase = ''
    patchShebangs tests/
    cd tests
    rm gpos_diff_test.py # needs ttxn?
    ./run_tests
  '';

  postInstall = ''
    cp -r third_party $out
  '';

  meta = {
    description = "Noto fonts support tools and scripts plus web site generation";
    license = lib.licenses.asl20;
    homepage = https://github.com/googlefonts/nototools;
  };
}
