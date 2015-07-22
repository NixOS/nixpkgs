
LUA_SO=liblua.so

$(LUA_SO): $(CORE_O) $(LIB_O)
	$(CC) -shared -ldl -Wl,-soname,$(LUA_SO).$(V) -o $@.$(R) $? -lm $(MYLDFLAGS)
	ln -sf $(LUA_SO).$(R) $(LUA_SO).$(V)
	ln -sf $(LUA_SO).$(R) $(LUA_SO)

