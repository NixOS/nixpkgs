{
  buildAstalModule,
  pam,
}:
buildAstalModule {
  name = "auth";
  buildInputs = [ pam ];
  meta.description = "Astal module for authentication using pam";
}
