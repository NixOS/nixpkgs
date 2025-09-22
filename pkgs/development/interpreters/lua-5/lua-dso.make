$(LUA_SO): $(CORE_O) $(LIB_O)
	$(CC) -shared $(LIBS) -Wl,-soname,$(LUA_SO).$(V) -o $@.$(R) $? $(MYLDFLAGS)
	ln -sf $(LUA_SO).$(R) $(LUA_SO).$(V)
	ln -sf $(LUA_SO).$(R) $(LUA_SO)
