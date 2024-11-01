{ mkDerivation
, extra-cmake-modules
, python3
, plasma-framework
, kcmutils
}:
mkDerivation {
  pname = "plasma-firewall";

  outputs = [ "out" ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    kcmutils
    plasma-framework
    python3
  ];
}
