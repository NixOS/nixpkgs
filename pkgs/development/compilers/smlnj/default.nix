{ lib, stdenv, fetchurl, Libsystem }:
let
  version = "110.99.6";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.hostPlatform.is64bit
    then "64"
    else "32";

  boot32 = { url = "${baseurl}/boot.x86-unix.tgz";
             hash = "sha256-7fk0x9lj9klYTljyeMuKaSyZocdAwFjXsNK7qP6MEaU="; };
  boot64 = { url = "${baseurl}/boot.amd64-unix.tgz";
             hash = "sha256-SHUYt/jJLUiuIIgCq3F/X20r30i3+FS2VJNsMpZMvUk="; };

  bootBinary = if stdenv.hostPlatform.is64bit
               then boot64
               else boot32;

  sources = map fetchurl [
    bootBinary
    { url = "${baseurl}/config.tgz";              hash = "sha256-aSOmbHFxqTOK/5xy6hNALqn6cqVXd+eJUS4N7KF/WoE="; }
    { url = "${baseurl}/cm.tgz";                  hash = "sha256-7RJSdgRcsm1TMFXbkUULwWpVYQzTjruG8aZemfDGuzk="; }
    { url = "${baseurl}/compiler.tgz";            hash = "sha256-HcDTHYkBM13fqkclx8MXTcT9jotfv7kqLLIq6ec0Er4="; }
    { url = "${baseurl}/runtime.tgz";             hash = "sha256-RgJ24Hxx7w3NzCD6VMxU+8NOKjLtDl6q8+zl0onnuB4="; }
    { url = "${baseurl}/system.tgz";              hash = "sha256-mP9k+Mivk0DyIfx5zl8yfZtaty6WoNSVd20PhvhZoAo="; }
    { url = "${baseurl}/MLRISC.tgz";              hash = "sha256-6zGuS5YRPwAZqyt7pk8fgtnjy/NIWsDnC5h8FsQ7qAU="; }
    { url = "${baseurl}/smlnj-lib.tgz";           hash = "sha256-kHXAFszzIR+glBJA7AjLGpGnRwh67CYO1MxZDZI4WVM="; }
    { url = "${baseurl}/old-basis.tgz";           hash = "sha256-VWoDwC8DVcmCMj4Ah/MBwJQgfLsfxn3GuhaMwblp3aI="; }
    { url = "${baseurl}/ckit.tgz";                hash = "sha256-jgFn4GPIWV2XcHYvCtOz/+GL1ja3L1yz4WokrOTaeXo="; }
    { url = "${baseurl}/nlffi.tgz";               hash = "sha256-9vJlWTqYfpA1FKM9QsxyPTAARIbpFs6AsrCl7CHteTI="; }
    { url = "${baseurl}/cml.tgz";                 hash = "sha256-B/9L1U/CVygIgCAjeJsbZXlg2wncayoDnZJqDp1/cp4="; }
    { url = "${baseurl}/eXene.tgz";               hash = "sha256-/z5Z+r3q6dwqXBo4Zncl313jjuWsc+p6+SrWlCJGl4E="; }
    { url = "${baseurl}/ml-lpt.tgz";              hash = "sha256-0AV1f5YaPSkMjlAv9nRzuKWEZn/uTy9eMGTrhwo9TrY="; }
    { url = "${baseurl}/ml-lex.tgz";              hash = "sha256-wd0QLoG4eHFQmcLs9g6Zs+XnC95v99YYzK2xq1rcB9c="; }
    { url = "${baseurl}/ml-yacc.tgz";             hash = "sha256-YRIkIKQ6k3HFLCCkNuh7gSuv6mHWFJAQcENuHqRrDKI="; }
    { url = "${baseurl}/ml-burg.tgz";             hash = "sha256-aeBxOHdsFNbxyQATKvX1HbeLzOHXA8Cdd+Sz6xgvi/k="; }
    { url = "${baseurl}/pgraph.tgz";              hash = "sha256-16jW36yw7S40/BZ1bEyHrRWsHo/MJz1Dkzex7JZRdeg="; }
    { url = "${baseurl}/trace-debug-profile.tgz"; hash = "sha256-oS1zB+1IuQCP3BCzop3UsV1RHLOI6sAUbi+JFhgw8ds="; }
    { url = "${baseurl}/heap2asm.tgz";            hash = "sha256-7mbuluXzIzqg69fjVndKJ4k+NHPm2q+n/VHRa+VJ6pk="; }
    { url = "${baseurl}/smlnj-c.tgz";             hash = "sha256-/cZ3vWQUSQKxBNUUQJ3U73R1bqJsVQ56A1n2BlhSAhU="; }
    { url = "${baseurl}/doc.tgz";                 hash = "sha256-Svv65apyManShajxZgUKrt40PWya++vVJnkAcnlx2eU="; }
    { url = "${baseurl}/asdl.tgz";                hash = "sha256-JZRyW3u1Z5iMNos2QgqNd1T2I0QAf9VNkpxHEZG0uVs="; }
  ];
in stdenv.mkDerivation {
  pname = "smlnj";
  inherit version;

  inherit sources;

  patchPhase = ''
    sed -i '/^PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
  '' + lib.optionalString stdenv.isDarwin ''
    # Locate standard headers like <unistd.h>
    substituteInPlace base/runtime/config/gen-posix-names.sh \
      --replace "\$SDK_PATH/usr" "${Libsystem}"
  '';

  unpackPhase = ''
    for s in $sources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
    unpackFile config.tgz
    mkdir base
    ./config/unpack $TMP runtime
  '';

  buildPhase = ''
    ./config/install.sh -default ${arch}
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv bin lib $out

    cd $out/bin
    for i in *; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = with lib; {
    description = "Standard ML of New Jersey, a compiler";
    homepage    = "http://smlnj.org";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "sml";
    # never built on x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
}
