{ lib
, fetchurl
, python3
, readline
, stdenv
, enableCurrenciesUpdater ? true
}:

let
  pythonEnv = python3.withPackages(p: [
    p.requests
  ]);
in stdenv.mkDerivation (finalAttrs: {
  pname = "units";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/units/units-${finalAttrs.version}.tar.gz";
    hash = "sha256-2Ve0USRZJcnmFMRRM5dEljDq+SvWK4SVugm741Ghc3A=";
  };

  outputs = [ "out" "info" "man" ];

  buildInputs = [
    readline
  ] ++ lib.optionals enableCurrenciesUpdater [
    pythonEnv
  ];

  prePatch = lib.optionalString enableCurrenciesUpdater ''
    substituteInPlace units_cur \
      --replace "#!/usr/bin/env python" ${pythonEnv}/bin/python
  '';

  postInstall = lib.optionalString enableCurrenciesUpdater ''
    cp units_cur ${placeholder "out"}/bin/
  '';

  doCheck = true;

  meta = {
    homepage = "https://www.gnu.org/software/units/";
    description = "Unit conversion tool";
    longDescription = ''
      GNU Units converts quantities expressed in various systems of measurement
      to their equivalents in other systems of measurement. Like many similar
      programs, it can handle multiplicative scale changes. It can also handle
      nonlinear conversions such as Fahrenheit to Celsius or wire gauge, and it
      can convert from and to sums of units, such as converting between meters
      and feet plus inches.

      Beyond simple unit conversions, GNU Units can be used as a general-purpose
      scientific calculator that keeps track of units in its calculations. You
      can form arbitrary complex mathematical expressions of dimensions
      including sums, products, quotients, powers, and even roots of
      dimensions. Thus you can ensure accuracy and dimensional consistency when
      working with long expressions that involve many different units that may
      combine in complex ways.

      The units are defined in an external data file. You can use the extensive
      data file that comes with this program, or you can provide your own data
      file to suit your needs. You can also use your own data file to supplement
      the standard data file.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "units";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
