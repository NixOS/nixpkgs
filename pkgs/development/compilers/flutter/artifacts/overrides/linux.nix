{
  gtk3,
}:

{
  buildInputs ? [ ],
  ...
}:

{
  # https://github.com/flutter/engine/pull/28525
  appendRunpaths = "$ORIGIN";

  buildInputs = buildInputs ++ [ gtk3 ];
}
