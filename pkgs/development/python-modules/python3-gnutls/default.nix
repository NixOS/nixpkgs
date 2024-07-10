{
  lib,
  fetchFromGitHub,
  substituteAll,
  buildPythonPackage,
  isPy3k,
  gnutls,
  twisted,
  pyopenssl,
  service-identity,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python3-gnutls";
  version = "3.1.10";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-gnutls";
    rev = "refs/tags/release-${version}";
    hash = "sha256-AdFRF3ZlkkAoSm5rvf/09FSYIo7SsZ38sD2joOLyukA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    twisted
    pyopenssl
    service-identity
  ];

  patches = [
    (substituteAll {
      src = ./libgnutls-path.patch;
      gnutlslib = "${lib.getLib gnutls}/lib";
    })
  ];

  pythonImportsCheck = [ "gnutls" ];

  meta = with lib; {
    description = "Python wrapper for the GnuTLS library";
    homepage = "https://github.com/AGProjects/python3-gnutls";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      This package provides a high level object oriented wrapper around libgnutls,
      as well as low level bindings to the GnuTLS types and functions via ctypes.
      The high level wrapper hides the details of accessing the GnuTLS library via
      ctypes behind a set of classes that encapsulate GnuTLS sessions, certificates
      and credentials and expose them to python applications using a simple API.

      The package also includes a Twisted interface that has seamless intergration
      with Twisted, providing connectTLS and listenTLS methods on the Twisted
      reactor once imported (the methods are automatically attached to the reactor
      by simply importing the GnuTLS Twisted interface module).

      The high level wrapper is written using the GnuTLS library bindings that are
      made available via ctypes. This makes the wrapper very powerful and flexible
      as it has direct access to all the GnuTLS internals and is also very easy to
      extend without any need to write C code or recompile anything.

    '';
  };
}
