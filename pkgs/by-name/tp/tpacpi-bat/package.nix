{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  kmod,
  coreutils,
}:

# Requires the acpi_call kernel module in order to run.
stdenv.mkDerivation rec {
  pname = "tpacpi-bat";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "teleshoes";
    repo = "tpacpi-bat";
    rev = "v${version}";
    sha256 = "sha256-9XnvVNdgB5VeI3juZfc8N5weEyULXuqu1IDChZfQqFk=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp tpacpi-bat $out/bin
  '';

  postPatch = ''
    substituteInPlace tpacpi-bat \
      --replace modprobe ${kmod}/bin/modprobe \
      --replace cat ${coreutils}/bin/cat
  '';

  meta = {
    maintainers = [ lib.maintainers.orbekk ];
    platforms = lib.platforms.linux;
    description = "Tool to set battery charging thresholds on Lenovo Thinkpad";
    mainProgram = "tpacpi-bat";
    license = lib.licenses.gpl3Plus;
  };
}
