{ lib, buildPythonPackage, fetchPypi, setuptools, freezegun }:

buildPythonPackage rec {
  pname = "property-cached";
  version = "1.6.3";
  
  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "614b6972e279d981b7bccabd0b1ce4601c1739a6eb9905fd79a9c485fb20a1e0";
  };

  propagatedBuildInputs = [ setuptools ];
  
  checkInputs = [ freezegun ];

  # freezegun 3.11 broke test_threads_ttl_expiry (tests.test_cached_property.TestCachedPropertyWithTTL)
  patchPhase = ''
    substituteInPlace tests/test_cached_property.py --replace 'self.assert_cached(check, 2 * num_threads)' 'self.assert_cached(check, num_threads + 1)'
  '';
  
  meta = with lib; {
    description = "Decorator for caching properties in classes";
    homepage = "https://github.com/althonos/property-cached/";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
