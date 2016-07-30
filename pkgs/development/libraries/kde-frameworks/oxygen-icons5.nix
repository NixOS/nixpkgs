{ kdeFramework
, lib
, ecm
}:

kdeFramework {
  name = "oxygen-icons5";
  meta = {
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.ttuegel ];
  };
  outputs = [ "out" ];
  nativeBuildInputs = [ ecm ];
}
