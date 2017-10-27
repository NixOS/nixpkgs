{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six }:


buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "MechanicalSoup";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wh93rml446ipx603n5z5i5bpan46pzliq6sw76d0ms9w7w2658d";
  };

  propagatedBuildInputs = [ requests beautifulsoup4 six ];

  meta = with lib; {
    description = "A Python library for automating interaction with websites";
    homepage = https://github.com/hickford/MechanicalSoup;
    license = licenses.mit;
    maintainers = [ maintainers.jgillich ];
  };
}
