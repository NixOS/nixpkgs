# in geoipDatabase, you can insert a package defining ${geoipDatabase}/share/GeoIP
# e.g. geolite-legacy
{ stdenv, fetchFromGitHub, autoreconfHook
, drvName ? "geoip", geoipDatabase ? "/var/lib/geoip-databases" }:

let version = "1.6.12";
    dataDir = if (stdenv.lib.isDerivation geoipDatabase) then "${toString geoipDatabase}/share/GeoIP" else geoipDatabase;
in stdenv.mkDerivation {
  name = "${drvName}-${version}";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoip-api-c";
    rev = "v${version}";
    sha256 = "0ixyp3h51alnncr17hqp1p0rlqz9w69nlhm60rbzjjz3vjx52ajv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  postConfigure = ''
    find . -name Makefile.in -exec sed -i -r 's#^pkgdatadir\s*=.+$#pkgdatadir = ${dataDir}#' {} \;
  '';

  meta = {
    description = "Geolocation API";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
    homepage = http://geolite.maxmind.com/;
    downloadPage = "http://geolite.maxmind.com/download/";
  };
}
