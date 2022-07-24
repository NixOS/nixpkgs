@@
expression SCHEMA_PATH;
expression settings;
@@
- settings = g_settings_new (SCHEMA_PATH);
+	{
+		GSettingsSchemaSource *schema_source;
+		GSettingsSchema *schema;
+		schema_source = g_settings_schema_source_new_from_directory("@ESD_GSETTINGS_PATH@",
+		                                                            g_settings_schema_source_get_default(),
+		                                                            TRUE,
+		                                                            NULL);
+		schema = g_settings_schema_source_lookup(schema_source, SCHEMA_PATH, FALSE);
+		settings = g_settings_new_full(schema, NULL, NULL);
+		g_settings_schema_source_unref(schema_source);
+		g_settings_schema_unref(schema);
+	}
