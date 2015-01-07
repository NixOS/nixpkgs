{

  overrideCabal = drv: f: drv.override (args: args // {
    mkDerivation = drv: args.mkDerivation (drv // f drv);
  });

}
