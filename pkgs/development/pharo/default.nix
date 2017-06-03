{ stdenv, callPackage, callPackage_i686, ...} @pkgs:

let
  vms_x86  = callPackage_i686 ./vm {};
  vms_x64  = callPackage ./vm {};
  cogvm = vms_x86.cog;
  spurvm = vms_x86.spur;
  spur64vm = if stdenv.is64bit then vms_x64.spur else "none";
  wrapper  = callPackage ./wrapper { inherit cogvm spurvm spur64vm; };
  images = callPackage ./images { pharo-vm = wrapper; };
in
    
{ vm = wrapper; } // images

