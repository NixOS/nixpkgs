_: prevAttrs: {
  badPlatformsConditions = prevAttrs.badPlatformsConditions or { } // {
    "Package is not supported; use drivers from linuxPackages" = true;
  };
}
