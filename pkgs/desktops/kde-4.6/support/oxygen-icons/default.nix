{kde, cmake}:

kde.package {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0yl5clp4dyxk6pg8lp3w3z44ayjhn7i47ww8n952mam5il6mlfl1";

  buildInputs = [ cmake ];
  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Contains icons for the KDE Oxygen theme, which is the default icon theme since KDE 4.3";
    license = "GPL";
    kde = {
      name = "oxygen-icons";
      version = "4.5.90";
    };
  };
}
