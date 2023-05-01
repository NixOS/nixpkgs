{ lib, stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, libkrb5
, pkg-config, libiconv
, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "serf";
  version = "1.3.9";

  src = fetchurl {
    url = "mirror://apache/serf/${pname}-${version}.tar.bz2";
    sha256 = "1k47gbgpp52049andr28y28nbwh9m36bbb0g8p0aka3pqlhjv72l";
  };

  nativeBuildInputs = [ pkg-config scons ];
  buildInputs = [ apr openssl aprutil zlib libiconv ]
    ++ lib.optional (!stdenv.isCygwin) libkrb5;

  patches = [
    ./scons.patch
    # https://issues.apache.org/jira/projects/SERF/issues/SERF-198
    (fetchpatch {
      url = "https://issues.apache.org/jira/secure/attachment/13019945/serf.patch";
      hash = "sha256-3djDGG30R/gq74KJL8OJ/upMh1zDpqtwGylRzN0lXpY=";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/libserf/raw/rawhide/f/libserf-1.3.9-errgetfunc.patch";
      hash = "sha256-FQJvXOIZ0iItvbbcu4kR88j74M7fOi7C/0NN3o1/ub4=";
    })
  ];

  prefixKey = "PREFIX=";

  preConfigure = ''
    sconsFlags+=" APR=$(echo ${apr.dev}/bin/*-config)"
    sconsFlags+=" APU=$(echo ${aprutil.dev}/bin/*-config)"
    sconsFlags+=" CC=$CC"
    sconsFlags+=" OPENSSL=${openssl}"
    sconsFlags+=" ZLIB=${zlib}"
  '' + lib.optionalString (!stdenv.isCygwin) ''
    sconsFlags+=" GSSAPI=${libkrb5.dev}"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "HTTP client library based on APR";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
