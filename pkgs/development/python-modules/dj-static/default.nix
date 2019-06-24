{ lib, fetchPypi, buildPythonPackage, django, static3 }:

buildPythonPackage rec {
  pname = "dj-static";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vz8ij123nhg5mhr8z0wzkjcq6pvlq2damp9wgk24yb16b2w2bh3";
  };

  doCheck = true;

  propagatedBuildInputs = [ django static3 ];

  meta = with lib; {
    description = "A simple Django middleware utility that allows you to properly serve static assets from production with a WSGI server like Gunicorn";
    homepage = "https://github.com/heroku-python/dj-static";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd2;
  };
}

