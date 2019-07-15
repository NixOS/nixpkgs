{ lib, fetchPypi, buildPythonPackage, six, cachetools }:

buildPythonPackage rec {
  pname = "airspeed";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jh5dpvh9rrybbk09f6vy8fnz9689qipjdz1zpvd34cd1ks9wvxa";
  };

  buildInputs = [ six cachetools ];

  doCheck = false;

  meta = {
    homepage = https://github.com/purcell/airspeed/;
    description = "python templating engine with compatibility iwth velocity";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.bsd3;
  };
}
