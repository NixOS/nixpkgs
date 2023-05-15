{ acstore
, artifacts
, bencode-py
, buildPythonPackage
, certifi
, cffi
, cryptography
, defusedxml
, dfdatetime
, dfvfs
, dfwinreg
, fakeredis
, fetchPypi
, flor
, future
, lib
, libbde-python
, libcreg-python
, libesedb-python
, libevt-python
, libevtx-python
, libewf-python
, libfsapfs-python
, libfsext-python
, libfsfat-python
, libfshfs-python
, libfsntfs-python
, libfsxfs-python
, libfvde-python
, libfwnt-python
, libfwsi-python
, liblnk-python
, libluksde-python
, libmodi-python
, libmsiecf-python
, libolecf-python
, libphdi-python
, libqcow-python
, libregf-python
, libscca-python
, libsigscan-python
, libsmdev-python
, libsmraw-python
, libvhdi-python
, libvmdk-python
, libvsgpt-python
, libvshadow-python
, libvslvm-python
, lz4
, mock
, opensearch-py
, pefile
, psutil
, pyparsing
, python-dateutil
, pytsk3
, pytz
, pyxattr
, pyyaml
, pyzmq
, redis
, requests
, six
, xlsxwriter
, yara-python
}:

buildPythonPackage rec {
  pname = "plaso";

  version = "20230311";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hruwIXFfKiIBG/oEjOHGQbhzJVIRNmdVcGAHitxidWQ=";
  };

  propagatedBuildInputs = [
    acstore
    artifacts
    bencode-py
    certifi
    cffi
    cryptography
    defusedxml
    dfdatetime
    dfvfs
    dfwinreg
    flor
    future
    libbde-python
    libcreg-python
    libesedb-python
    libevt-python
    libevtx-python
    libewf-python
    libfsapfs-python
    libfsext-python
    libfsfat-python
    libfshfs-python
    libfsntfs-python
    libfsxfs-python
    libfvde-python
    libfwnt-python
    libfwsi-python
    liblnk-python
    libluksde-python
    libmodi-python
    libmsiecf-python
    libolecf-python
    libphdi-python
    libqcow-python
    libregf-python
    libscca-python
    libsigscan-python
    libsmdev-python
    libsmraw-python
    libvhdi-python
    libvmdk-python
    libvsgpt-python
    libvshadow-python
    libvslvm-python
    lz4
    opensearch-py
    pefile
    psutil
    pyparsing
    python-dateutil
    pytsk3
    pytz
    pyxattr
    pyyaml
    pyzmq
    redis
    requests
    six
    xlsxwriter
    yara-python
  ];

  nativeCheckInputs = [ mock fakeredis ];

  doCheck = false;

  meta = with lib; {
    description =
      "Plaso (Plaso Langar Að Safna Öllu), or super timeline all the things, is a Python-based engine used by several tools for automatic creation of timelines";
    homepage = "https://github.com/log2timeline/plaso";
    downloadPage = "https://github.com/log2timeline/plaso/releases";
    maintainers = [ maintainers.jayrovacsek ];
    license = licenses.asl20;
  };
}
