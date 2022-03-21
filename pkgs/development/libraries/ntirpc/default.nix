{ lib, stdenv, fetchFromGitHub, cmake
, krb5, liburcu , libtirpc, libnsl
} :

stdenv.mkDerivation rec {
  pname = "ntirpc";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "nfs-ganesha";
    repo = "ntirpc";
    rev = "v${version}";
    sha256 = "0hffma57b4c7g7862yvfr8bvbsbxh5w383mvjkjv3jpzi01l79yv";
  };

  postPatch = ''
    substituteInPlace ntirpc/netconfig.h --replace "/etc/netconfig" "$out/etc/netconfig"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ krb5 liburcu libnsl ];

  postInstall = ''
    mkdir -p $out/etc

    # Library needs a netconfig to run.
    # Steal the file from libtirpc
    cp ${libtirpc}/etc/netconfig $out/etc/
  '';

  meta = with lib; {
    description = "Transport-independent RPC (TI-RPC)";
    homepage = "https://github.com/nfs-ganesha/ntirpc";
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
