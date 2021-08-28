{ lib, buildPythonPackage, fetchPypi, fetchpatch, pytest }:

buildPythonPackage rec {
  version = "0.5.1";
  pname = "pytest-dependency";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2a892906192663f85030a6ab91304e508e546cddfe557d692d61ec57a1d946b";
  };

  patches = [
    # Fix build with pytest ≥ 6.2.0, https://github.com/RKrahl/pytest-dependency/pull/51
    (fetchpatch {
      url = "https://github.com/RKrahl/pytest-dependency/commit/0930889a13e2b9baa7617f05dc9b55abede5209d.patch";
      sha256 = "0ka892j0rrlnfvk900fcph0f6lsnr9dy06q5k2s2byzwijhdw6n5";
    })
  ];

  buildInputs = [ pytest ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/RKrahl/pytest-dependency";
    description = "Manage dependencies of tests";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
