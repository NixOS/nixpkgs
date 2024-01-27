{ lib, buildPythonPackage, libusbsio }:

buildPythonPackage rec {
  pname = "libusbsio";
  format = "setuptools";
  inherit (libusbsio) version;

  src = "${libusbsio.src}/python";

  # The source includes both the python module directly and also a source tarball for it.
  # The direct files lack setup information, the tarball includes unwanted binaries.
  # This takes only the setup files from the tarball.
  postUnpack = ''
    tar -C python --strip-components=1 -xf python/dist/libusbsio-${version}.tar.gz libusbsio-${version}/{setup.py,setup.cfg,pyproject.toml}
    rm -r python/dist
  '';

  postPatch = ''
    substituteInPlace libusbsio/libusbsio.py \
        --replace "dllpath = LIBUSBSIO._lookup_dll_path(dfltdir, dllname)" 'dllpath = "${libusbsio}/lib/" + dllname'
  '';

  buildInputs = [ libusbsio ];

  doCheck = false; # they require a device to be connected over USB

  pythonImportsCheck = [ "libusbsio" ];

  meta = with lib; {
    description = "NXP Secure Provisioning SDK";
    homepage = "https://github.com/NXPmicro/spsdk";
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
