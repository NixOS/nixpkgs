{
  gtk3,
}:

{
  buildInputs ? [ ],
  ...
}:

{
  buildInputs = buildInputs ++ [ gtk3 ];
}
