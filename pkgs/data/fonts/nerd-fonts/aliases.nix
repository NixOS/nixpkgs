{
  nerd-fonts,
  lib,
}:
{
  mplus =
    lib.warnOnInstantiate "nerd-fonts.mplus has been renamed to nerd-fonts.\"m+\""
      nerd-fonts."m+";
}
