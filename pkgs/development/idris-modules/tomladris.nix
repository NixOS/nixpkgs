{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lightyear,
  lib,
}:
build-idris-package {
  pname = "tomladris";
  version = "2017-11-14";

  idrisDeps = [
    lightyear
    contrib
  ];

  src = fetchFromGitHub {
    owner = "emptyflash";
    repo = "tomladris";
    rev = "0fef663e20528c455f410f01124c8e3474a96606";
    sha256 = "0a0fc0bsr356plgzsr5sr4qmqx4838998wjwmflz10qwsv1j3zsw";
  };

  meta = {
    description = "TOML parser for Idris";
    homepage = "https://github.com/emptyflash/tomladris";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      siddharthist
      brainrape
    ];
  };
}
