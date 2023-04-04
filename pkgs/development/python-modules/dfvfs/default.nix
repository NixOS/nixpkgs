{ buildPythonPackage, fetchPypi, lib, cffi, cryptography, dfdatetime, dtfabric
, libbde-python, libewf-python, libfsapfs-python, libfsext-python
, libfsfat-python, libfshfs-python, libfsntfs-python, libfsxfs-python
, libfvde-python, libfwnt-python, libluksde-python, libmodi-python
, libphdi-python, libqcow-python, libsigscan-python, libsmdev-python
, libsmraw-python, libvhdi-python, libvmdk-python, libvsgpt-python
, libvshadow-python, libvslvm-python, pytsk3, pyxattr, pyyaml }:
buildPythonPackage rec {
  pname = "dfvfs";
  name = pname;
  version = "20221224";

  meta = with lib; {
    description =
      "dfVFS, or Digital Forensics Virtual File System, provides read-only access to file-system objects from various storage media types and file formats";
    platforms = platforms.all;
    homepage = "https://github.com/log2timeline/dfvfs";
    downloadPage = "https://github.com/log2timeline/dfvfs/releases";
    maintainers = with maintainers; [ jayrovacsek ];
    license = licenses.asl20;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IxkoXVDUztPKf+m3UxLLxneUuPgTBvkikTyButPIKeA=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    cffi
    cryptography
    dfdatetime
    dtfabric
    libbde-python
    libewf-python
    libfsapfs-python
    libfsext-python
    libfsfat-python
    libfshfs-python
    libfsntfs-python
    libfsxfs-python
    libfvde-python
    libfwnt-python
    libluksde-python
    libmodi-python
    libphdi-python
    libqcow-python
    libsigscan-python
    libsmdev-python
    libsmraw-python
    libvhdi-python
    libvmdk-python
    libvsgpt-python
    libvshadow-python
    libvslvm-python
    pytsk3
    pyxattr
    pyyaml
  ];
}
