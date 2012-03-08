{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "78f35ceba58bd34059ca4b2107bb55d4de56733e8932ba2ea22dcac18ee995ce";

  buildNativeInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
