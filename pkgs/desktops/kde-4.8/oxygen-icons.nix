{ kde, cmake }:

kde {
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "ca03ee0a7bbd35ee70f84d32b6f861ee8c019473f16c6ecf6309885317bcfe51";

  buildNativeInputs = [ cmake ];

  meta = {
    description = "KDE Oxygen theme icons";
    longDescription = "Icons for KDE's default theme";
    license = "GPL";
  };
}
