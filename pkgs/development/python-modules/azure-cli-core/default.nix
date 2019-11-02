{ stdenv
, lib
, python
, buildPythonPackage
, fetchPypi
, adal
, antlr4-python3-runtime
, argcomplete
, azure-cli-telemetry
, colorama
, jmespath
, humanfriendly
, knack
, msrest
, msrestazure
, paramiko
, pygments
, pyjwt
, pyopenssl
, pyyaml
, requests
, six
, tabulate
, azure-mgmt-resource
, pyperclip
, psutil
, enum34
, futures
, antlr4-python2-runtime
, ndg-httpsclient
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-cli-core";
  version = "2.0.75";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6fde38f4448542c0cf7b13201b702c6927180e7294221b8f67e2c834f22ae1bc";
  };

  propagatedBuildInputs = [
    adal
    argcomplete
    azure-cli-telemetry
    colorama
    jmespath
    humanfriendly
    knack
    msrest
    msrestazure
    paramiko
    pygments
    pyjwt
    pyopenssl
    pyyaml
    requests
    six
    tabulate
    azure-mgmt-resource
    pyperclip
    psutil
  ]
  ++ lib.optionals isPy3k [ antlr4-python3-runtime ]
  ++ lib.optionals (!isPy3k) [ enum34 futures antlr4-python2-runtime ndg-httpsclient ];

  # Remove overly restrictive version contraints and obsolete namespace setup
  prePatch = ''
    substituteInPlace setup.py \
      --replace "wheel==0.30.0" "wheel" \
      --replace "azure-mgmt-resource==2.1.0" "azure-mgmt-resource"
    substituteInPlace setup.cfg \
      --replace "azure-namespace-package = azure-cli-nspkg" ""
  '';

  # Prevent these __init__'s from violating PEP420, only needed for python2
  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py \
       $out/${python.sitePackages}/azure/cli/__init__.py
  '';

  # Tests are not included in sdist package
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/Azure/azure-cli;
    description = "Next generation multi-platform command line experience for Azure";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
