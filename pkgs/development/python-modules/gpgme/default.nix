{
  autoreconfHook,
  buildPythonPackage,
  fetchurl,
  gnupg,
  gpgme,
  lib,
  libgpg-error,
  setuptools,
  swig,
}:

buildPythonPackage rec {
  pname = "gpgme";
  version = "2.0.0";
  pyproject = true;

  src = fetchurl {
    url = "mirror://gnupg/gpgmepy/gpgmepy-${version}.tar.bz2";
    hash = "sha256-B+EmVkj/UdojjJr3oYs/HcewxmtPIacvJ8dLOWzTM20=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "swig"' ""

    # prevent `packaging.version.InvalidVersion: Invalid version: '2.0.0-unknown'`
    substituteInPlace autogen.sh \
      --replace-fail 'tmp="-unknown"' 'tmp=""'
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    autoreconfHook
    gpgme # for gpgme-config
    libgpg-error # for gpg-error-config
    swig
  ];

  preBuild = ''
    # prevent `error: package directory 'gpg' does not exist`
    mv src gpg
  '';

  buildInputs = [
    gpgme
    libgpg-error
  ];

  pythonImportsCheck = [ "gpg" ];

  nativeCheckInputs = [
    gnupg
  ];

  checkPhase = ''
    runHook preCheck

    make -C tests

    runHook postCheck
  '';

  meta = {
    changelog = "https://dev.gnupg.org/source/gpgmepy/browse/master/NEWS;gpgmepy-${version}?as=remarkup";
    description = "Python bindings to the GPGME API of the GnuPG cryptography library";
    homepage = "https://dev.gnupg.org/source/gpgmepy/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
