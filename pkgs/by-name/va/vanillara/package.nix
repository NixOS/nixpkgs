{
  vanillatd,
  ...
}@args:

vanillatd.override (
  {
    appName = "vanillara";
  }
  // removeAttrs args [ "vanillatd" ]
)
