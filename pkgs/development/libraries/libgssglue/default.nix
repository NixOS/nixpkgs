{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  libkrb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgssglue";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "gsasl";
    repo = "libgssglue";
    rev = "tags/libgssglue-${finalAttrs.version}";
    hash = "sha256-p9dujLklv2ZC1YA1gKGCRJf9EvF3stv5v4Z/5m1nSeM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    touch ChangeLog

    sed s:/etc/gssapi_mech.conf:$out/etc/gssapi_mech.conf: -i src/g_initialize.c
  '';

  postInstall = ''
    mkdir -p $out/etc
    cat <<EOF > $out/etc/gssapi_mech.conf
    ${libkrb5}/lib/libgssapi_krb5.so mechglue_internal_krb5_init
    EOF
  '';

  meta = with lib; {
    homepage = "http://www.citi.umich.edu/projects/nfsv4/linux/";
    description = "Exports a gssapi interface which calls other random gssapi libraries";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ corngood ];
  };
})
