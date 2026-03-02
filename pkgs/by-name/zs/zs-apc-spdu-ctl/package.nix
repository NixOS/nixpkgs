{
  cmake,
  fetchFromGitHub,
  fping,
  lib,
  libowlevelzs,
  net-snmp,
  stdenv,
}:

# TODO: add a services entry for the /etc/zs-apc-spdu.conf file
stdenv.mkDerivation (finalAttrs: {
  pname = "zs-apc-spdu-ctl";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "fogti";
    repo = "zs-apc-spdu-ctl";
    rev = "v${finalAttrs.version}";
    sha256 = "TMV9ETWBVeXq6tZ2e0CrvHBXoyKfOLCQurjBdf/iw/M=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libowlevelzs
    net-snmp
  ];

  postPatch = ''
    substituteInPlace src/confent.cxx \
      --replace /usr/sbin/fping "${fping}/bin/fping"
  '';

  meta = {
    description = "APC SPDU control utility";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "zs-apc-spdu-ctl";
  };
})
