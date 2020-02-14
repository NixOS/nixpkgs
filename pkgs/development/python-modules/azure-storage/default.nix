{ pkgs
, buildPythonPackage
, fetchPypi
, python
, azure-common
, futures
, dateutil
, requests
, isPy3k
}:

buildPythonPackage rec {
  version = "0.20.3";
  pname = "azure-storage";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "06bmw6k2000kln5jwk5r9bgcalqbyvqirmdh9gq4s6nb4fv3c0jb";
  };

  propagatedBuildInputs = [ azure-common dateutil requests ]
                            ++ pkgs.lib.optionals (!isPy3k) [ futures ];

  postInstall = ''
    echo "__import__('pkg_resources').declare_namespace(__name__)" >> "$out/lib/${python.libPrefix}"/site-packages/azure/__init__.py
  '';

  meta = with pkgs.lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ olcai ];
  };
}
