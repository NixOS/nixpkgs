{ pkgs
, buildPythonPackage
, fetchPypi
, azure-core
, typing-extensions
}:

buildPythonPackage rec {
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "azure-mgmt-core";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-0ZUgg0AJT5jlpmYbeBzeb2oFHnnOMXyqvY/5cDCps64=";
=======
    hash = "sha256-B/Sv6COlXXBLBI1h7f3BMYwFHtWfJEAyEmNQvpXp1QE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-core
    typing-extensions
  ];

  pythonNamespaces = "azure.mgmt";

  # not included
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.core" "azure.core" ];

  meta = with pkgs.lib; {
    description = "Microsoft Azure Management Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
