{
  buildPecl,
  lib,
  pkg-config,
  rrdtool,
}:

buildPecl {
  pname = "rrd";

  version = "2.0.3";
  hash = "sha256-pCFh5YzcioU7cs/ymJidy96CsPdkVt1ZzgKFTJK3MPc=";

  buildInputs = [
    rrdtool
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "PHP bindings to RRD tool system";
    license = licenses.bsd0;
    homepage = "https://github.com/php/pecl-processing-rrd";
    maintainers = teams.wdz.members;
  };
}
